import { useEffect, useState } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate, useParams } from "react-router-dom";
import { ExpenseFileApi } from "@/api/ExpenseFileApi";
import { FileResponse } from "@/types/Interfaces";
import ViewFile from "@/components/custom/ViewFile";

export function ViewExpense() {
  const { token } = useAuthStore();
  const { expenseId } = useParams();
  const navigate = useNavigate();
  const [fileResponse, setFileResponse] = useState<FileResponse>({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!token) {
      navigate("/login");
    }
  }, [token, navigate]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        if (token) {
          setLoading(true);
          const response = await ExpenseFileApi.getExpenseFile(
            expenseId,
            token
          );
          setFileResponse(response);
        }
      } catch (error) {
        console.error("Error fetching expense file:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (token) {
    return (
      <>
        <div>
          <h1 className="text-4xl font-bold text-gray-800 mt-4 mb-4 underline">
            View Expense
          </h1>
          {loading ? (
            <div className="spinner-border text-primary" role="status">
              <span className="visually-hidden">Loading...</span>
            </div>
          ) : (
            <ViewFile fileResponse={fileResponse} />
          )}
        </div>
      </>
    );
  }

  return null;
}
