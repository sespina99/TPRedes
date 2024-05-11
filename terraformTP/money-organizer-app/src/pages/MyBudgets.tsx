import { useEffect } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate } from "react-router-dom";
import BudgetsList from "@/components/custom/BudgetsList";

export function MyBudgets() {
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
        <h1 className="text-4xl font-bold text-gray-800 mt-4 mb-4 underline">My Budgets</h1>
        <BudgetsList />
      </>
    );
  }

  return null;
}
