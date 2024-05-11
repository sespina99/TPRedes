import { Route, Routes } from "react-router-dom";
import { MyBudgets } from "@/pages/MyBudgets";
import { MyExpenses } from "@/pages/MyExpenses";
import { AddExpense } from "@/pages/AddExpense";
import { AddBudget } from "@/pages/AddBudget";
import { UpdateExpense } from "@/pages/UpdateExpense";
import { UpdateBudget } from "@/pages/UpdateBudget";
import { NotFound } from "@/pages/NotFound";
import { SignUp } from "@/pages/SignUp";
import { Login } from "@/pages/Login";
import { ShareBudget } from "@/pages/ShareBudget";
import { ViewBudget } from "@/pages/ViewBudget";
import { ViewExpense } from "@/pages/ViewExpense";

const AppRoutes = () => {
  return (
    <>
      <Routes>
        <Route path="/" element={<MyExpenses />} />
        <Route path="/login" element={<Login />} />
        <Route path="/sign-up" element={<SignUp />} />
        <Route path="/my-expenses" element={<MyExpenses />} />
        <Route path="/expenses/:expenseId" element={<ViewExpense />} />
        <Route path="/my-budgets" element={<MyBudgets />} />
        <Route path="/budgets/:budgetId" element={<ViewBudget />} />
        <Route path="/add-expense" element={<AddExpense />} />
        <Route path="/add-budget" element={<AddBudget />} />
        <Route path="/update-expense" element={<UpdateExpense />} />
        <Route path="/update-budget" element={<UpdateBudget />} />
        <Route path="/share-budget" element={<ShareBudget />} />
        <Route path="/*" element={<NotFound />} />
      </Routes>
    </>
  );
};

export default AppRoutes;
