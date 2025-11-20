const { test, expect } = require('@playwright/test');

test.describe('Ecommerce Application E2E Tests', () => {
  const baseUrl = 'https://harry-ecommerce-frontend.azurewebsites.net';

  test('should load homepage and display products', async ({ page }) => {
    await page.goto(baseUrl);
    await expect(page.locator('h1')).toContainText('Ecommerce Store');
    await expect(page.locator('.product-card')).toHaveCountGreaterThan(0);
  });

  test('should register new user', async ({ page }) => {
    await page.goto(baseUrl);
    await page.click('button:has-text("Register")');
    
    await page.fill('input[placeholder="Username"]', 'testuser' + Date.now());
    await page.fill('input[placeholder="Email"]', 'test' + Date.now() + '@example.com');
    await page.fill('input[placeholder="Password"]', 'password123');
    
    await page.click('button[type="submit"]');
    await expect(page.locator('text=Welcome')).toBeVisible();
  });

  test('should add product to cart', async ({ page }) => {
    await page.goto(baseUrl);
    
    const firstProduct = page.locator('.product-card').first();
    await firstProduct.locator('button:has-text("Add to Cart")').click();
    
    await expect(page.locator('.cart-summary')).toContainText('Cart: 1 items');
  });

  test('should complete checkout flow', async ({ page }) => {
    await page.goto(baseUrl);
    
    // Register user
    await page.click('button:has-text("Register")');
    await page.fill('input[placeholder="Username"]', 'checkoutuser' + Date.now());
    await page.fill('input[placeholder="Email"]', 'checkout' + Date.now() + '@example.com');
    await page.fill('input[placeholder="Password"]', 'password123');
    await page.click('button[type="submit"]');
    
    // Add product to cart
    const firstProduct = page.locator('.product-card').first();
    await firstProduct.locator('button:has-text("Add to Cart")').click();
    
    // Go to checkout
    await page.click('button:has-text("Checkout")');
    
    // Fill checkout form
    await page.fill('input[name="address"]', '123 Test Street');
    await page.fill('input[name="cardNumber"]', '4111111111111111');
    await page.fill('input[name="expiryDate"]', '12/25');
    await page.fill('input[name="cvv"]', '123');
    
    await page.click('button:has-text("Place Order")');
    
    // Verify order completion
    await expect(page.locator('text=Order')).toBeVisible();
  });
});