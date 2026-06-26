import type { PlannerInput, Itinerary } from '@/types';

const API_BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

export async function createItinerary(input: PlannerInput): Promise<Itinerary> {
  const res = await fetch(`${API_BASE}/itineraries`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(input),
    credentials: 'include',
  });
  if (!res.ok) {
    const err = await res.json();
    throw new Error(err.message ?? 'Unknown error');
  }
  return res.json();
}

export async function getItinerary(id: number): Promise<Itinerary> {
  const res = await fetch(`${API_BASE}/itineraries/${id}`, {
    credentials: 'include',
  });
  if (!res.ok) throw new Error('Itinerary not found');
  return res.json();
}
