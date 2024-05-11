import { useEffect } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate, useLocation } from "react-router-dom";
import ShareBudgetForm from "@/components/custom/ShareBudgetForm";

export function ShareBudget() {
  const { token } = useAuthStore();
  const navigate = useNavigate();
  const { state } = useLocation();
  const { budget } = state;

  useEffect(() => {
    if (!token) {
      navigate("/login");
    }
  }, [token, navigate]);

  if (token) {
    return (
      <>
        <ShareBudgetForm budget={budget} />
      </>
    );
  }

  return null;
}
