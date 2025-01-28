const { test, expect } = require('@playwright/test');

test('hello world', async ({ page }) => {
  await page.goto('http://localhost:3000'); // Замените на URL вашего приложения
  await expect(page).toHaveTitle(/Radio/); // Проверьте, что заголовок страницы содержит "Radio"
});