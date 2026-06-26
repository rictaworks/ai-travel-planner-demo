'use client';

import Link from 'next/link';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faTree,
  faUtensils,
  faLandmark,
  faShoppingBag,
  faBolt,
  faSpa,
  faCalendarDay,
  faYenSign,
  faClock,
  faExclamationTriangle,
  faArrowLeft,
} from '@fortawesome/free-solid-svg-icons';
import type { Itinerary, Category, TimeSlot } from '@/types';
import type { Translations } from '@/lib/i18n/ja';

const CATEGORY_ICONS: Record<Category, typeof faTree> = {
  nature: faTree,
  gourmet: faUtensils,
  historical: faLandmark,
  shopping: faShoppingBag,
  activity: faBolt,
  relax: faSpa,
};

interface Props {
  itinerary: Itinerary;
  t: Translations;
}

export default function ItineraryResult({ itinerary, t }: Props) {
  const totalCost = itinerary.days
    .flatMap((d) => d.items)
    .reduce((sum, item) => sum + item.cost, 0);

  return (
    <div className="space-y-6">
      {/* Fallback notice */}
      {itinerary.fallback && (
        <div className="flex items-start gap-3 p-4 bg-yellow-900/40 border border-yellow-600 rounded-lg text-yellow-300 text-sm">
          <FontAwesomeIcon icon={faExclamationTriangle} className="mt-0.5 flex-shrink-0" />
          <span>{t.fallbackNotice}</span>
        </div>
      )}

      {/* Days */}
      {itinerary.days.map((day) => (
        <div key={day.day_number} className="bg-[#16161a] rounded-xl overflow-hidden">
          <div className="flex items-center gap-2 px-5 py-3 bg-blue-900/30 border-b border-gray-700">
            <FontAwesomeIcon icon={faCalendarDay} className="text-[#2a52cc]" />
            <h2 className="font-semibold text-white">
              {day.day_number}{t.day}
            </h2>
          </div>
          <div className="divide-y divide-gray-700/50">
            {day.items.map((item, idx) => (
              <div key={`${item.spot_id}-${idx}`} className="flex items-start gap-4 px-5 py-4">
                <div className="flex-shrink-0 w-9 h-9 rounded-lg bg-blue-900/20 flex items-center justify-center">
                  <FontAwesomeIcon
                    icon={CATEGORY_ICONS[item.category]}
                    className="text-[#2a52cc]"
                  />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="font-medium text-white">{item.spot_name}</p>
                  <p className="text-xs text-gray-400 mt-0.5">
                    {t.categories[item.category]} &bull; {t.timeSlots[item.time_slot as TimeSlot]}
                  </p>
                </div>
                <div className="flex flex-col items-end gap-1 text-sm text-gray-300">
                  <span className="flex items-center gap-1">
                    <FontAwesomeIcon icon={faYenSign} className="text-xs text-[#2a52cc]" />
                    {item.cost.toLocaleString()}
                  </span>
                  <span className="flex items-center gap-1 text-xs text-gray-400">
                    <FontAwesomeIcon icon={faClock} className="text-xs" />
                    {item.duration_min}{t.minutes}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      ))}

      {/* Total cost */}
      <div className="flex items-center justify-between px-5 py-4 bg-[#16161a] rounded-xl">
        <span className="font-medium text-gray-300">{t.totalCost}</span>
        <span className="flex items-center gap-1 text-xl font-bold text-white">
          <FontAwesomeIcon icon={faYenSign} className="text-[#2a52cc]" />
          {totalCost.toLocaleString()}
          <span className="text-sm font-normal ml-1 text-gray-400">{t.yen}</span>
        </span>
      </div>

      {/* Back button */}
      <Link
        href="/"
        className="flex items-center justify-center gap-2 w-full py-3 px-6 border border-gray-600 hover:border-[#2a52cc] text-gray-300 hover:text-white rounded-xl transition-colors"
      >
        <FontAwesomeIcon icon={faArrowLeft} />
        {t.backToTop}
      </Link>
    </div>
  );
}
