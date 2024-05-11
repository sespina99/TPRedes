import { useEffect } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate } from "react-router-dom";
import AddExpenseForm from "@/components/custom/AddExpenseForm";

export function AddExpense() {
  const { token } = useAuthStore();
  const navigate = useNavigate();

  useEffect(() => {
    if (!token) {
      navigate("/login");
    }
  }, [token, navigate]);

  if (token) {
    return (
      <>
        <AddExpenseForm />
      </>
    );
  }

  return null;
}
