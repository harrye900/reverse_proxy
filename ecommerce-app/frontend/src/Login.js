import React, { useState } from 'react';
import axios from 'axios';

function Login({ onLogin, onSwitchToRegister }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:5001/api/auth/login', {
        username,
        password
      });
      
      if (response.data.success) {
        onLogin(response.data.user);
      } else {
        setError(response.data.message);
      }
    } catch (error) {
      setError('Login failed. Please try again.');
    }
  };

  return (
    <div className="login-container">
      <form onSubmit={handleSubmit} className="login-form">
        <h2>Login to Ecommerce Store</h2>
        
        {error && <div className="error">{error}</div>}
        
        <div className="form-group">
          <input
            type="text"
            placeholder="Username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>
        
        <div className="form-group">
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        
        <button type="submit">Login</button>
        
        <div className="demo-accounts">
          <p>Demo accounts:</p>
          <p>Username: admin, Password: admin123</p>
          <p>Username: user, Password: user123</p>
        </div>
        
        <div className="switch-auth">
          <p>Don't have an account? 
            <button type="button" onClick={onSwitchToRegister} className="link-btn">Register</button>
          </p>
        </div>
      </form>
    </div>
  );
}

export default Login;