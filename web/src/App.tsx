import {
  BrowserRouter,
  Routes,
  Route,
} from "react-router-dom";
import TestDemoPage from "@/pages/TestDemoPage.tsx";
import EventDetailsPage from "./pages/Events/EventDetailsPage";
import UserTicketsPage from "./pages/Events/UserTicketsPage";

export default function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<TestDemoPage/>}/>
                <Route path="/events/:id" element={<EventDetailsPage/>}/>
                <Route path="/my-tickets" element={<UserTicketsPage/>}/>
            </Routes>
        </BrowserRouter>
    );
  }

