import {
  BrowserRouter,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";
import TestDemoPage from "@/pages/TestDemoPage.tsx";
import EventsPage from "@/pages/EventsPage.tsx";
import LoginPage from "@/pages/LoginPage.tsx";
import RegisterPage from "@/pages/RegisterPage.tsx";
import { PrivateRoute } from "@/components/PrivateRoute.tsx";

function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<Navigate to="/events" replace />} />
                <Route path="/login" element={<LoginPage/>}/>
                <Route path="/register" element={<RegisterPage/>}/>
                <Route
                    path="/events"
                    element={
                        <PrivateRoute>
                            <EventsPage/>
                        </PrivateRoute>
                    }
                />
                <Route path="/demo" element={<TestDemoPage/>}/>
            </Routes>
        </BrowserRouter>
    );
}

export default App;