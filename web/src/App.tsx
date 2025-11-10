import {
  BrowserRouter,
  Routes,
  Route,
} from "react-router-dom";
import TestDemoPage from "@/pages/TestDemoPage.tsx";
import EventDetailsPage from "./pages/EventDetails/EventDetailsPage";

export default function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<TestDemoPage/>}/>
                <Route path="/events/:id" element={<EventDetailsPage/>}/>
            </Routes>
        </BrowserRouter>
    );
  }

