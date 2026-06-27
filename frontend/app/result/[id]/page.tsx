import { cookies } from 'next/headers';
import { notFound } from 'next/navigation';
import { getTranslations, type Locale } from '@/lib/i18n';
import ItineraryResult from '@/components/ItineraryResult';
import type { Itinerary } from '@/types';

interface PageProps {
  params: Promise<{ id: string }>;
}

const API_BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

export default async function ResultPage({ params }: PageProps) {
  const { id } = await params;
  const cookieStore = await cookies();
  const locale = (cookieStore.get('locale')?.value ?? 'ja') as Locale;
  const t = getTranslations(locale);

  const itineraryId = parseInt(id, 10);
  if (isNaN(itineraryId)) notFound();

  // Server-side fetch must forward the browser's signed session cookie
  // so Railway can verify ownership (owner_session_id).
  const cookieHeader = cookieStore.getAll().map(c => `${c.name}=${c.value}`).join('; ');

  let itinerary: Itinerary;
  try {
    const res = await fetch(`${API_BASE}/itineraries/${itineraryId}`, {
      headers: { Cookie: cookieHeader },
      cache: 'no-store',
    });
    if (!res.ok) notFound();
    itinerary = await res.json();
  } catch {
    notFound();
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">{t.yourItinerary}</h1>
      </div>
      <ItineraryResult itinerary={itinerary} t={t} />
    </div>
  );
}
