import {
  BrowserRouter,
  Routes,
  Route,
} from "react-router-dom";
import TestDemoPage from "@/pages/TestDemoPage.tsx";

function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<TestDemoPage/>}/>
            </Routes>
        </BrowserRouter>
    );
  }
}
