import React, { useState } from 'react';
import axios from 'axios';

function Checkout({ cart, user, onCheckoutComplete }) {
  const [address, setAddress] = useState('');
  const [cardNumber, setCardNumber] = useState('');
  const [expiryDate, setExpiryDate] = useState('');
  const [cvv, setCvv] = useState('');
  const [cardHolderName, setCardHolderName] = useState('');
  const [email, setEmail] = useState('');
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [loading, setLoading] = useState(false);

  const totalAmount = cart.reduce((total, item) => total + (item.price * item.quantity), 0);

  const handleCheckout = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      // Process checkout
      const checkoutResponse = await axios.post('http://localhost:5002/api/checkout', {
        userId: user ? user.id : 0,
        items: cart,
        totalAmount,
        shippingAddress: address,
        guestInfo: user ? null : { name, email, phone }
      });

      if (checkoutResponse.data.success) {
        // Process payment
        const paymentResponse = await axios.post('http://localhost:5003/api/payment/process', {
          orderId: checkoutResponse.data.order.id,
          amount: totalAmount,
          cardNumber,
          expiryDate,
          cvv,
          cardHolderName
        });

        if (paymentResponse.data.success) {
          onCheckoutComplete(checkoutResponse.data.order, paymentResponse.data.payment);
        } else {
          alert('Payment failed: ' + paymentResponse.data.message);
        }
      }
    } catch (error) {
      alert('Checkout failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="checkout-container">
      <h2>Checkout</h2>
      
      <div className="checkout-summary">
        <h3>Order Summary</h3>
        {cart.map(item => (
          <div key={item.productId} className="checkout-item">
            <span>{item.productName} x {item.quantity}</span>
            <span>${(item.price * item.quantity).toFixed(2)}</span>
          </div>
        ))}
        <div className="checkout-total">Total: ${totalAmount.toFixed(2)}</div>
      </div>

      <form onSubmit={handleCheckout} className="checkout-form">
        {!user && (
          <div className="guest-info">
            <h3>Contact Information</h3>
            <div className="form-group">
              <input
                type="text"
                placeholder="Full Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
              />
            </div>
            <div className="form-group">
              <input
                type="email"
                placeholder="Email Address"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="form-group">
              <input
                type="tel"
                placeholder="Phone Number"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                required
              />
            </div>
          </div>
        )}
        
        <h3>Shipping Information</h3>
        <div className="form-group">
          <input
            type="text"
            placeholder="Shipping Address"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
            required
          />
        </div>
        
        <h3>Payment Information</h3>
        <div className="form-group">
          <input
            type="text"
            placeholder="Card Number"
            value={cardNumber}
            onChange={(e) => setCardNumber(e.target.value)}
            required
          />
        </div>
        
        <div className="form-row">
          <input
            type="text"
            placeholder="MM/YY"
            value={expiryDate}
            onChange={(e) => setExpiryDate(e.target.value)}
            required
          />
          <input
            type="text"
            placeholder="CVV"
            value={cvv}
            onChange={(e) => setCvv(e.target.value)}
            required
          />
        </div>
        
        <div className="form-group">
          <input
            type="text"
            placeholder="Card Holder Name"
            value={cardHolderName}
            onChange={(e) => setCardHolderName(e.target.value)}
            required
          />
        </div>
        
        <button type="submit" disabled={loading}>
          {loading ? 'Processing...' : 'Complete Order'}
        </button>
      </form>
    </div>
  );
}

export default Checkout;