import type { EventDTO } from "../services/EventService";

type EventCardProps = {
  event: EventDTO;
  onClick?: (id: number) => void;
};

export function EventCard({ event, onClick }: EventCardProps) {
  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString("uk-UA", {
      day: "numeric",
      month: "long",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const participantsPercent = event.max_participants > 0
    ? ((event.current_participants || 0) / event.max_participants) * 100
    : 0;

  return (
    <div
      className="group relative bg-white rounded-xl border border-slate-200 hover:border-blue-300 shadow-sm hover:shadow-xl transition-all duration-300 cursor-pointer overflow-hidden"
      onClick={() => onClick?.(event.id)}
    >
      {/* Default Image */}
      <div className="relative h-48 bg-gradient-to-br from-blue-400 via-purple-400 to-pink-400 overflow-hidden">
        <div className="absolute inset-0 flex items-center justify-center">
          <svg className="w-24 h-24 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
        </div>
        {/* Gradient overlay on hover */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
      </div>

      <div className="p-6">
        <h3 className="text-xl font-bold mb-3 text-slate-900 group-hover:text-blue-600 transition-colors line-clamp-2">
          {event.title}
        </h3>

        <p className="text-slate-600 mb-5 line-clamp-3 leading-relaxed">
          {event.description}
        </p>

        <div className="space-y-3">
          {/* Location */}
          <div className="flex items-start gap-3 text-sm text-slate-700">
            <svg className="w-5 h-5 text-blue-500 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <span className="flex-1">{event.location}</span>
          </div>

          {/* Date */}
          <div className="flex items-start gap-3 text-sm text-slate-700">
            <svg className="w-5 h-5 text-purple-500 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
            <span className="flex-1">{formatDate(event.start_date)}</span>
          </div>

          {/* Participants */}
          <div className="space-y-2">
            <div className="flex items-center gap-3 text-sm text-slate-700">
              <svg className="w-5 h-5 text-pink-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
              <span className="font-medium">
                {event.current_participants || 0} / {event.max_participants} учасників
              </span>
            </div>

            {/* Progress bar */}
            <div className="w-full bg-slate-100 rounded-full h-2 overflow-hidden">
              <div
                className={`h-full rounded-full transition-all duration-500 ${
                  participantsPercent >= 90 ? 'bg-red-500' :
                  participantsPercent >= 70 ? 'bg-orange-500' :
                  'bg-gradient-to-r from-blue-500 to-purple-500'
                }`}
                style={{ width: `${Math.min(participantsPercent, 100)}%` }}
              ></div>
            </div>
          </div>
        </div>
      </div>

      {/* Hover effect overlay */}
      <div className="absolute inset-0 border-2 border-transparent group-hover:border-blue-400 rounded-xl pointer-events-none transition-colors"></div>
    </div>
  );
}

