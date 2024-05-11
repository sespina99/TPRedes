import { useEffect } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate, useLocation } from "react-router-dom";
import UpdateExpenseForm from "@/components/custom/UpdateExpenseForm";

export function UpdateExpense() {
  const { token } = useAuthStore();
  const navigate = useNavigate();
  const { state } = useLocation();
  const { expense } = state;

  useEffect(() => {
    if (!token) {
      navigate("/login");
    }
  }, [token, navigate]);

  if (token) {
    return (
      <>
        <UpdateExpenseForm expense={ expense }/>
      </>
    );
  }

  return null;
}
