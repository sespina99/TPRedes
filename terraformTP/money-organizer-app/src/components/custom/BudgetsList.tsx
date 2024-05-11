import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { toast } from "@/components/ui/use-toast.ts";
import { useNavigate } from "react-router-dom";
import { BudgetApi } from "@/api/BudgetApi";
import { BudgetFileApi } from "@/api/BudgetFileApi";
import { useEffect, useState } from "react";
import { Budget } from "@/types/Interfaces";
import { useAuthStore } from "@/hooks/useAuthStore";

const BudgetsList = () => {
  const { token } = useAuthStore();

  const navigate = useNavigate();

  const [loading, setLoading] = useState(true);
  const [budgets, setBudgets] = useState<Budget[]>([]);
  useEffect(() => {
    const fetchData = async () => {
      try {
        if (token) {
          setLoading(true);
          const budgets = await BudgetApi.getBudgets(token);
          setBudgets(budgets);
        }
      } catch (error) {
        console.error("Error fetching budgets:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const handlePreviousVersion = async (budgetId: string | undefined) => {
    setLoading(true);
    if (token) {
      const data = await BudgetFileApi.revertBudgetFile(budgetId, token);
      toast({
        title: data,
      });
    }
    setLoading(false);
  };

  return (
    <>
      {loading ? (
        <div style={{ overflowX: "auto" }}>
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
        </div>
      ) : (
        <>
          {budgets.length === 0 ? (
            <p>No Budgets available</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-[100px]">Name</TableHead>
                  <TableHead>Link</TableHead>
                  <TableHead>Subscribers</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {budgets.map((budget) => (
                  <TableRow key={budget.id}>
                    <TableCell className="font-medium">{budget.name}</TableCell>
                    <TableCell>
                      <div>
                        <a
                          style={{
                            color: "blue",
                            textDecoration: "underline",
                            cursor: "pointer",
                          }}
                          href={`${import.meta.env.VITE_FE_BASE_URL}/budgets/${
                            budget.id
                          }`}
                        >
                          {`${import.meta.env.VITE_FE_BASE_URL}/budgets/${
                            budget.id
                          }`}
                        </a>
                      </div>
                    </TableCell>
                    <TableCell className="font-medium">
                      {budget.subscribers
                        ? Array.from(new Set(budget.subscribers)).join(" - ")
                        : ""}
                    </TableCell>
                    <TableCell>
                      <div>
                        <Button
                          onClick={() =>
                            navigate("/update-budget", { state: { budget } })
                          }
                        >
                          Edit
                        </Button>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Button
                        onClick={() =>
                          navigate("/share-budget", { state: { budget } })
                        }
                      >
                        Share
                      </Button>
                    </TableCell>
                    <TableCell>
                      <Button onClick={() => navigate(`/budgets/${budget.id}`)}>
                        View
                      </Button>
                    </TableCell>
                    <TableCell>
                      <Button onClick={() => handlePreviousVersion(budget.id)}>
                        Revert to <br /> Previous version
                      </Button>
                    </TableCell>
                    <TableCell>
                      <Button
                        onClick={() => {
                          if (token) {
                            BudgetApi.deleteBudget(budget.id, token);
                            setBudgets(
                              budgets.filter((b) => b.id != budget.id)
                            );
                          }
                        }}
                      >
                        Delete
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </>
      )}
      <Button className="mt-6" onClick={() => navigate("/add-budget")}>
        Add budget
      </Button>
    </>
  );
};

export default BudgetsList;
