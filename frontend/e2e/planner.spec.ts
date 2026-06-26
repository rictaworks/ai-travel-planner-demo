import { test, expect } from '@playwright/test';

test('旅程生成の主要フローが動作すること', async ({ page }) => {
  await page.goto('http://localhost:3000');
  await page.selectOption('[name="trip_days"]', '2');
  await page.fill('[name="budget_total"]', '10000');
  await page.click('[value="sunny"]');
  await page.click('button[type="submit"]');
  await expect(page.locator('h2')).toBeVisible({ timeout: 10000 });
});
