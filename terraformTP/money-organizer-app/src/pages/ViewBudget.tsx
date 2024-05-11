import { useEffect, useState } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate, useParams } from "react-router-dom";
import { BudgetFileApi } from "@/api/BudgetFileApi";
import { FileResponse } from "@/types/Interfaces";
import ViewFile from "@/components/custom/ViewFile";

export function ViewBudget() {
  const { token } = useAuthStore();
  const { budgetId } = useParams();
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
          const response = await BudgetFileApi.getBudgetFile(budgetId, token);
          setFileResponse(response);
        }
      } catch (error) {
        console.error("Error fetching budget file:", error);
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
            View budget
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
