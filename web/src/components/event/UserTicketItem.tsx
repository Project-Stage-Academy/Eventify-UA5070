import { ChevronDown, Calendar, MapPin, Ticket } from "lucide-react";
import type { Event } from "@/services/EventService";
import { formatDate } from "@/utils/formatters";

interface UserTicketItemProps {
  event: Event;
  onExpand: () => void;
  tickets: any[];
  isExpanded: boolean;
  isLoadingTickets: boolean;
}

export function UserTicketItem({ 
  event, 
  onExpand, 
  tickets, 
  isExpanded, 
  isLoadingTickets 
}: UserTicketItemProps) {
  
  return (
    <div className="bg-white rounded-2xl shadow-lg overflow-hidden transition-all duration-300 hover:shadow-xl border border-gray-100">
      <div
        onClick={onExpand}
        className="cursor-pointer p-6 flex items-center gap-6"
      >
        <div className="w-24 h-24 md:w-32 md:h-32 rounded-xl overflow-hidden shrink-0 bg-gray-100">
          {event.image_url ? (
            <img
              src={event.image_url}
              alt={event.title}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-gray-400">
              <Calendar className="w-12 h-12" />
            </div>
          )}
        </div>

        <div className="flex-1 min-w-0">
          <h2 className="text-xl md:text-2xl font-bold text-gray-800 mb-2 truncate">
            {event.title}
          </h2>
          
          <div className="space-y-1">
            <div className="flex items-center text-gray-600 text-sm md:text-base flex-wrap gap-2">
              <div className="flex items-center">
                <Calendar className="w-4 h-4 mr-2 shrink-0 text-red-600" />
                <span>{formatDate(event.start_date)}</span>
              </div>
              <span className="text-gray-400">—</span>
              <span>{formatDate(event.finish_date)}</span>
            </div>
            
            <div className="flex items-center text-gray-600 text-sm md:text-base">
              <MapPin className="w-4 h-4 mr-2 shrink-0 text-red-600" />
              <span className="truncate">{event.location}</span>
            </div>
          </div>

          <div className="mt-2 inline-flex items-center text-sm text-gray-700 font-medium">
            <Ticket className="w-4 h-4 mr-1 text-red-600" />
            Tickets: {tickets.length ? tickets.length : '...'}
          </div>
        </div>

        <ChevronDown
          className={`w-6 h-6 text-gray-400 shrink-0 transition-transform duration-300 ${
            isExpanded ? 'rotate-180' : ''
          }`}
        />
      </div>

      <div
        className={`transition-all duration-300 ease-in-out ${
          isExpanded ? 'max-h-[500px] opacity-100' : 'max-h-0 opacity-0'
        } overflow-hidden`}
      >
        <div className="border-t border-gray-200 px-6 py-5 bg-white">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">
            Your tickets:
          </h3>
          
          {isLoadingTickets ? (
            <div className="flex items-center justify-center py-8">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-red-600"></div>
              <span className="ml-3 text-gray-600">Loading tickets...</span>
            </div>
          ) : tickets.length > 0 ? (
            <div className="space-y-3 max-h-80 overflow-y-auto pr-2">
              {tickets.map((ticket) => (
                <div
                  key={ticket.id}
                  className="bg-gray-50 rounded-xl p-4 border border-gray-200 hover:border-gray-300 transition-colors"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <span className="inline-block px-3 py-1 bg-red-100 text-red-700 text-sm font-medium rounded-full">
                          Ticket #{ticket.id}
                        </span>
                        {ticket.status && (
                          <span className={`text-xs px-2 py-1 rounded-full font-medium ${
                            ticket.status === 'confirmed' 
                              ? 'bg-green-100 text-green-700' 
                              : ticket.status === 'pending'
                              ? 'bg-yellow-100 text-yellow-700'
                              : 'bg-gray-100 text-gray-700'
                          }`}>
                            {ticket.status}
                          </span>
                        )}
                      </div>
                      {ticket.comment && (
                        <p className="text-gray-600 text-sm">
                          {ticket.comment}
                        </p>
                      )}
                      {ticket.created_at && (
                        <p className="text-gray-500 text-xs mt-1">
                          Registered: {formatDate(ticket.created_at)}
                        </p>
                      )}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-gray-500 text-center py-8">
              No tickets to display
            </p>
          )}
        </div>
      </div>
    </div>
  );
}