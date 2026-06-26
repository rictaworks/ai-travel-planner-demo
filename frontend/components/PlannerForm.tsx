'use client';

import { useState, FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faTree,
  faUtensils,
  faLandmark,
  faShoppingBag,
  faBolt,
  faSpa,
  faSun,
  faCloud,
  faCloudRain,
  faSnowflake,
  faCalendarAlt,
  faYenSign,
  faPaperPlane,
} from '@fortawesome/free-solid-svg-icons';
import { createItinerary } from '@/lib/api';
import type { Category, Weather, Preference, PlannerInput } from '@/types';
import type { Translations } from '@/lib/i18n/ja';

const CATEGORIES: { value: Category; icon: typeof faTree }[] = [
  { value: 'nature', icon: faTree },
  { value: 'gourmet', icon: faUtensils },
  { value: 'historical', icon: faLandmark },
  { value: 'shopping', icon: faShoppingBag },
  { value: 'activity', icon: faBolt },
  { value: 'relax', icon: faSpa },
];

const WEATHERS: { value: Weather; icon: typeof faSun }[] = [
  { value: 'sunny', icon: faSun },
  { value: 'cloudy', icon: faCloud },
  { value: 'rainy', icon: faCloudRain },
  { value: 'snowy', icon: faSnowflake },
];

interface Props {
  t: Translations;
}

export default function PlannerForm({ t }: Props) {
  const router = useRouter();
  const [tripDays, setTripDays] = useState<number>(1);
  const [budget, setBudget] = useState<string>('');
  const [selectedCategories, setSelectedCategories] = useState<Category[]>([]);
  const [weather, setWeather] = useState<Weather>('sunny');
  const [honeypot, setHoneypot] = useState<string>('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  function toggleCategory(category: Category) {
    setSelectedCategories((prev) =>
      prev.includes(category)
        ? prev.filter((c) => c !== category)
        : [...prev, category]
    );
  }

  function buildPreferences(): Preference[] {
    return selectedCategories.map((category, index) => ({
      category,
      priority: index + 1,
    }));
  }

  async function handleSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();

    if (honeypot !== '') return;

    if (tripDays < 1 || tripDays > 3) {
      setError(t.validationDays);
      return;
    }
    const budgetNum = parseInt(budget, 10);
    if (!budget || isNaN(budgetNum) || budgetNum <= 0) {
      setError(t.validationBudget);
      return;
    }

    setError(null);
    setLoading(true);

    const input: PlannerInput = {
      trip_days: tripDays,
      budget_total: budgetNum,
      preferences: buildPreferences(),
      expected_weather: weather,
      honeypot,
    };

    try {
      const itinerary = await createItinerary(input);
      router.push(`/result/${itinerary.id}`);
    } catch (err) {
      setError(err instanceof Error ? err.message : t.errorOccurred);
    } finally {
      setLoading(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-8" noValidate>
      {/* Honeypot - hidden from real users */}
      <input
        type="text"
        name="website"
        value={honeypot}
        onChange={(e) => setHoneypot(e.target.value)}
        style={{ display: 'none' }}
        tabIndex={-1}
        autoComplete="off"
        aria-hidden="true"
      />

      {/* Trip Days */}
      <div className="space-y-2">
        <label className="flex items-center gap-2 text-sm font-medium text-gray-300">
          <FontAwesomeIcon icon={faCalendarAlt} className="text-[#2a52cc]" />
          {t.tripDays}
        </label>
        <select
          name="trip_days"
          value={tripDays}
          onChange={(e) => setTripDays(Number(e.target.value))}
          className="w-full bg-[#16161a] border border-gray-700 rounded-lg px-4 py-3 text-white focus:outline-none focus:border-[#2a52cc]"
          required
        >
          <option value={1}>1</option>
          <option value={2}>2</option>
          <option value={3}>3</option>
        </select>
      </div>

      {/* Budget */}
      <div className="space-y-2">
        <label className="flex items-center gap-2 text-sm font-medium text-gray-300">
          <FontAwesomeIcon icon={faYenSign} className="text-[#2a52cc]" />
          {t.budget}
        </label>
        <input
          type="number"
          name="budget_total"
          value={budget}
          onChange={(e) => setBudget(e.target.value)}
          min={1}
          className="w-full bg-[#16161a] border border-gray-700 rounded-lg px-4 py-3 text-white focus:outline-none focus:border-[#2a52cc]"
          required
        />
      </div>

      {/* Preferences */}
      <div className="space-y-3">
        <label className="block text-sm font-medium text-gray-300">
          {t.preferences}
        </label>
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
          {CATEGORIES.map(({ value, icon }) => {
            const isSelected = selectedCategories.includes(value);
            const priority = selectedCategories.indexOf(value) + 1;
            return (
              <button
                key={value}
                type="button"
                onClick={() => toggleCategory(value)}
                className={`relative flex items-center gap-2 p-3 rounded-lg border transition-all ${
                  isSelected
                    ? 'border-[#2a52cc] bg-blue-900/20 text-white'
                    : 'border-gray-700 bg-[#16161a] text-gray-400 hover:border-gray-500'
                }`}
              >
                <FontAwesomeIcon icon={icon} />
                <span className="text-sm">{t.categories[value]}</span>
                {isSelected && (
                  <span className="absolute top-1 right-1 text-xs bg-[#2a52cc] text-white rounded-full w-4 h-4 flex items-center justify-center">
                    {priority}
                  </span>
                )}
              </button>
            );
          })}
        </div>
      </div>

      {/* Weather */}
      <div className="space-y-3">
        <label className="block text-sm font-medium text-gray-300">
          {t.weather}
        </label>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          {WEATHERS.map(({ value, icon }) => (
            <label
              key={value}
              className={`flex flex-col items-center gap-2 p-3 rounded-lg border cursor-pointer transition-all ${
                weather === value
                  ? 'border-[#2a52cc] bg-blue-900/20 text-white'
                  : 'border-gray-700 bg-[#16161a] text-gray-400 hover:border-gray-500'
              }`}
            >
              <input
                type="radio"
                name="expected_weather"
                value={value}
                checked={weather === value}
                onChange={() => setWeather(value)}
                className="sr-only"
              />
              <FontAwesomeIcon icon={icon} className="text-xl" />
              <span className="text-sm">{t.weathers[value]}</span>
            </label>
          ))}
        </div>
      </div>

      {/* Error message */}
      {error && (
        <div role="alert" className="p-4 bg-red-900/50 border border-red-700 rounded-lg text-red-300 text-sm">
          {error}
        </div>
      )}

      {/* Submit */}
      <button
        type="submit"
        disabled={loading}
        className="w-full flex items-center justify-center gap-2 py-4 px-6 bg-[#2a52cc] hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed text-white font-semibold rounded-xl transition-colors"
      >
        <FontAwesomeIcon icon={faPaperPlane} />
        {loading ? t.generating : t.generate}
      </button>
    </form>
  );
}
