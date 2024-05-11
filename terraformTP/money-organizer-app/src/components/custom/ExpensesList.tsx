import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";

import { expenseApi } from "@/api/ExpenseApi";
import { useEffect, useState } from "react";
import { Expense } from "@/types/Interfaces";
import { useAuthStore } from "@/hooks/useAuthStore";

//The timestamp here is in milliseconds
const formatDateFromEpoch = (epochTimestamp: number, timeZone = "UTC") => {
  const date = new Date(epochTimestamp);

  // Format the date to a string using the specified timezone
  const formattedDate = date.toLocaleString("en-GB", {
    month: "2-digit",
    day: "2-digit",
    year: "numeric",
    timeZone,
  });

  return formattedDate;
};

const ExpensesList = () => {
  const { token } = useAuthStore();

  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);

  let [expenses, setExpenses] = useState<Expense[]>([]);
  useEffect(() => {
    const fetchData = async () => {
      try {
        if (token) {
          setLoading(true);
          const expenses = await expenseApi.getExpenses(token);
          setExpenses(expenses);
        }
      } catch (error) {
        console.error("Error fetching expenses:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  return (
    <>
      {loading ? (
        <div>
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
        </div>
      ) : (
        <>
          {expenses.length === 0 ? (
            <p>No Expenses available</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-[100px]">Name</TableHead>
                  <TableHead>Date</TableHead>
                  <TableHead>Category</TableHead>
                  <TableHead className="text-right">Amount</TableHead>
                  <TableHead className="text-right">Description</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {expenses.map((expense) => (
                  <TableRow key={expense.id}>
                    <TableCell className="font-medium">
                      {expense.name}
                    </TableCell>
                    <TableCell>{formatDateFromEpoch(expense.date)}</TableCell>
                    <TableCell>{expense.category}</TableCell>
                    <TableCell className="text-right">
                      ${expense.amount}
                    </TableCell>
                    <TableCell className="text-right">
                      {expense.description}
                    </TableCell>
                    <TableCell>
                      <Button
                        onClick={() =>
                          navigate("/update-expense", { state: { expense } })
                        }
                      >
                        Edit
                      </Button>
                    </TableCell>
                    <TableCell>
                      <Button
                        onClick={() => navigate(`/expenses/${expense.id}`)}
                        disabled={!expense.has_pdf}
                      >
                        View
                      </Button>
                    </TableCell>
                    <TableCell>
                      <Button
                        onClick={() => {
                          if (token && expense.id) {
                            expenseApi.deleteExpense(expense.id, token);
                            setExpenses(
                              expenses.filter((e) => e.id != expense.id)
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
      <Button className="mt-6" onClick={() => navigate("/add-expense")}>
        Add expense
      </Button>
    </>
  );
};

export default ExpensesList;
