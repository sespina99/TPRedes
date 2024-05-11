import { useEffect } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate } from "react-router-dom";
import AddBudgetForm from "@/components/custom/AddBudgetForm";

export function AddBudget() {
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
        <AddBudgetForm />
      </>
    );
  }

  return null;
}
