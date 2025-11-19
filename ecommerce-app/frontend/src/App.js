import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Login from './Login';
import Register from './Register';
import Checkout from './Checkout';
import './App.css';

function App() {
  const [products, setProducts] = useState([]);
  const [cart, setCart] = useState([]);
  const [user, setUser] = useState(null);
  const [showLogin, setShowLogin] = useState(false);
  const [showRegister, setShowRegister] = useState(false);
  const [showCheckout, setShowCheckout] = useState(false);

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const apiUrl = process.env.REACT_APP_API_URL || 'http://localhost:5000';
      const response = await axios.get(`${apiUrl}/api/products`);
      setProducts(response.data);
    } catch (error) {
      console.error('Error fetching products:', error);
    }
  };

  const addToCart = (product) => {
    const existingItem = cart.find(item => item.productId === product.id);
    if (existingItem) {
      setCart(cart.map(item => 
        item.productId === product.id 
          ? { ...item, quantity: item.quantity + 1 }
          : item
      ));
    } else {
      setCart([...cart, {
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity: 1
      }]);
    }
  };

  const getTotalPrice = () => {
    return cart.reduce((total, item) => total + (item.price * item.quantity), 0).toFixed(2);
  };

  const handleLogin = (userData) => {
    setUser(userData);
    setShowLogin(false);
    setShowRegister(false);
  };

  const handleRegister = (userData) => {
    setUser(userData);
    setShowLogin(false);
    setShowRegister(false);
  };

  const handleLogout = () => {
    setUser(null);
    setCart([]);
    setShowCheckout(false);
  };

  const handleCheckoutComplete = (order, payment) => {
    alert(`Order #${order.id} completed! Transaction: ${payment.transactionId}`);
    setCart([]);
    setShowCheckout(false);
  };

  if (showLogin) {
    return <Login onLogin={handleLogin} onSwitchToRegister={() => { setShowLogin(false); setShowRegister(true); }} />;
  }

  if (showRegister) {
    return <Register onRegister={handleRegister} onSwitchToLogin={() => { setShowRegister(false); setShowLogin(true); }} />;
  }

  if (showCheckout) {
    return <Checkout cart={cart} user={user} onCheckoutComplete={handleCheckoutComplete} />;
  }

  return (
    <div className="App">
      <header>
        <h1>Ecommerce Store</h1>
        <div className="auth-buttons">
          {user ? (
            <div className="user-info">
              Welcome, {user.username}!
              <button onClick={handleLogout} className="logout-btn">Logout</button>
            </div>
          ) : (
            <div className="guest-buttons">
              <button onClick={() => setShowLogin(true)} className="login-btn">Login</button>
              <button onClick={() => setShowRegister(true)} className="register-btn">Register</button>
            </div>
          )}
        </div>
        <div className="cart-summary">
          Cart: {cart.length} items | Total: ${getTotalPrice()}
          {cart.length > 0 && (
            <button onClick={() => setShowCheckout(true)} className="checkout-btn">Checkout</button>
          )}
        </div>
      </header>

      <main>
        <div className="products-grid">
          {products.map(product => (
            <div key={product.id} className="product-card">
              <img src={product.imageUrl} alt={product.name} />
              <h3>{product.name}</h3>
              <p>{product.description}</p>
              <div className="price">${product.price}</div>
              <button onClick={() => addToCart(product)}>Add to Cart</button>
            </div>
          ))}
        </div>

        {cart.length > 0 && (
          <div className="cart">
            <h2>Shopping Cart</h2>
            {cart.map(item => (
              <div key={item.productId} className="cart-item">
                <span>{item.productName}</span>
                <span>Qty: {item.quantity}</span>
                <span>${(item.price * item.quantity).toFixed(2)}</span>
              </div>
            ))}
            <div className="cart-total">Total: ${getTotalPrice()}</div>
          </div>
        )}
      </main>
    </div>
  );
}

export default App;