import { useEffect } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate, useLocation } from "react-router-dom";
import UpdateBudgetForm from "@/components/custom/UpdateBudgetForm";

export function UpdateBudget() {
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
        <UpdateBudgetForm budget={ budget } />
      </>
    );
  }

  return null;
}
