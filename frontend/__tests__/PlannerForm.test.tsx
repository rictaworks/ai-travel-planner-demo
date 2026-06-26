import React from 'react';
import { render, screen } from '@testing-library/react';
import PlannerForm from '@/components/PlannerForm';
import { ja } from '@/lib/i18n/ja';

jest.mock('next/navigation', () => ({
  useRouter: () => ({ push: jest.fn() }),
  usePathname: () => '/',
}));

jest.mock('@/lib/api', () => ({
  createItinerary: jest.fn(),
}));

jest.mock('@fortawesome/react-fontawesome', () => ({
  FontAwesomeIcon: () => null,
}));

describe('PlannerForm', () => {
  it('renders the form with all required fields', () => {
    render(<PlannerForm t={ja} />);
    expect(screen.getByRole('combobox')).toBeInTheDocument();
  });

  it('honeypot field exists and is hidden', () => {
    const { container } = render(<PlannerForm t={ja} />);
    const honeypot = container.querySelector('input[name="website"]');
    expect(honeypot).not.toBeNull();
    expect(honeypot).toHaveStyle({ display: 'none' });
  });

  it('submit button renders with generate label', () => {
    render(<PlannerForm t={ja} />);
    expect(screen.getByRole('button', { name: /旅程を生成する/i })).toBeInTheDocument();
  });
});
