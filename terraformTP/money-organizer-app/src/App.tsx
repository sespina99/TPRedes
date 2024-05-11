import "./App.css";
import AppRoutes from "./components/utils/AppRoutes";
import Navbar from "./components/custom/Navbar";
import "bootstrap/dist/css/bootstrap.css";
import { Toaster } from "@/components/ui/toaster";
import { useAuthStore } from "./hooks/useAuthStore";
import { Worker } from "@react-pdf-viewer/core";

function App() {
  const { token } = useAuthStore();

  return (
    <>
      <Worker workerUrl="https://unpkg.com/pdfjs-dist@3.4.120/build/pdf.worker.min.js">
        <div>
          {token !== null ? <Navbar /> : null}
          <AppRoutes />
          <Toaster />
        </div>
      </Worker>
    </>
  );
}

export default App;
