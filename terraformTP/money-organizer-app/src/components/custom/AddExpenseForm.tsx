import { FormEvent, useState } from "react";
import { expenseApi } from "@/api/ExpenseApi";
import { toast } from "@/components/ui/use-toast.ts";
import { useNavigate } from "react-router-dom";

import { useAuthStore } from "@/hooks/useAuthStore";

const AddExpenseForm = () => {
  const { token } = useAuthStore();
  const navigate = useNavigate();

  const [name, setName] = useState("");
  const [category, setCategory] = useState("");
  const [amount, setAmount] = useState(0);
  //date type
  const [expenseDate, setExpenseDate] = useState("");
  const [description, setDescription] = useState("");
  const [pdfFile, setPdfFile] = useState(null); // State to store the selected PDF file

  const [isHovered, setIsHovered] = useState(false);

  const handleMouseEnter = () => {
    setIsHovered(true);
  };

  const handleMouseLeave = () => {
    setIsHovered(false);
  };

  const convertPdfToBase64 = (pdfFile: any) => {
    return new Promise((resolve, reject) => {
      if (!pdfFile) {
        reject(new Error("No PDF file provided"));
        return;
      }

      const reader = new FileReader();

      reader.onloadend = () => {
        const base64String =
          typeof reader.result === "string"
            ? reader.result.split(",")[1]
            : null;
        if (base64String) {
          resolve(base64String);
        } else {
          reject(new Error("Failed to convert PDF to base64"));
        }
      };

      reader.readAsDataURL(pdfFile);
    });
  };

  const handleFileChange = (e: any) => {
    const selectedFile = e.target.files[0];

    // Check if a file is selected
    if (selectedFile) {
      // Check if the selected file is a PDF
      if (selectedFile.type === "application/pdf") {
        setPdfFile(selectedFile);
      } else {
        // Display an error message or take appropriate action
        alert("Please select a PDF file.");
        // Clear the input field
        e.target.value = null;
      }
    }
  };

  const handleCategoryChange = (e: any) => {
    setCategory(e.target.value);
  };

  const handleNameChange = (e: any) => {
    setName(e.target.value);
  };

  const handleAmountChange = (e: any) => {
    setAmount(e.target.value);
  };

  const handleDescriptionChange = (e: any) => {
    setDescription(e.target.value);
  };

  const currentDate = new Date().toISOString().split("T")[0];

  const handleDateChange = (e: any) => {
    setExpenseDate(e.target.value);
  };
  const [loading, setLoading] = useState(false);

  const handleAddExpense = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setLoading(true);

    if (pdfFile) {
      const pdfString = await convertPdfToBase64(pdfFile);
      const expense = {
        name,
        category,
        amount,
        description,
        date: new Date(expenseDate).getTime(),
        bill_file: pdfString as string,
      };
      try {
        expenseApi
          .createExpense({ ...expense }, token ?? "")
          .then(() => {
            toast({
              title: `Expense Created`,
              description: `Expense with name = ${expense.name} created succesfully`,
            });
            navigate("/my-expenses");
          })
          .catch(() => {
            toast({
              title: `Error creating expense`,
              description: `Error during creating expense. Probably because the pdf is too large`,
            });
            setLoading(false);
          });
      } catch (error) {
        console.log(error);
      }
    } else {
      const expense = {
        name,
        category,
        amount,
        description,
        date: new Date(expenseDate).getTime(),
      };

      try {
        expenseApi.createExpense({ ...expense }, token ?? "").then(() => {
          toast({
            title: `Expense Created`,
            description: `Expense with name = ${expense.name} created succesfully`,
          });
          navigate("/my-expenses");
        })
        .catch(() => {
            toast({
              title: `Error creating Expense`,
              description: `Error during expense creation.`,
            });
            setLoading(false);
          });
      } catch (error) {
        console.log(error);
      }
    }
  };

  const buttonStyle = {
    backgroundColor: isHovered ? "#004080" : "#007bff", // Set the primary background color
    color: "#fff", // Set text color
  };

  const handleCancel = () => {
    // Handle cancel logic if needed
    navigate("/my-expenses"); // Change the route as needed
  };

  return (
    <div className="container mt-4">
      <h2 className="text-4xl font-bold text-gray-800 mt-4 mb-4 underline">
        Add Expense
      </h2>
      <form onSubmit={handleAddExpense}>
        <div className="mb-3 row">
          <label htmlFor="name" className="col-sm-3 col-form-label text-end">
            * Expense Name:
          </label>
          <div className="col-sm-6">
            <input
              type="text"
              className="form-control"
              id="description"
              placeholder="Dinner with friends"
              onChange={handleNameChange}
              disabled={loading}
              required
            />
          </div>
        </div>
        <div className="mb-3 row">
          <label htmlFor="pdfFile" className="col-sm-3 col-form-label text-end">
            PDF File:
          </label>
          <div className="col-sm-6">
            <input
              type="file"
              className="form-control"
              id="pdfFile"
              accept=".pdf"
              onChange={handleFileChange}
              disabled={loading}
            />
          </div>
        </div>
        <div className="mb-3 row">
          <label
            htmlFor="category"
            className="col-sm-3 col-form-label text-end"
          >
            * Category:
          </label>
          <div className="col-sm-6">
            <input
              type="text"
              className="form-control"
              id="category"
              placeholder="Food"
              onChange={handleCategoryChange}
              disabled={loading}
              required
            />
          </div>
        </div>
        <div className="mb-3 row">
          <label
            htmlFor="expenseDate"
            className="col-sm-3 col-form-label text-end"
          >
            * Expense Date:
          </label>
          <div className="col-sm-6">
            <input
              type="date"
              className="form-control"
              id="expenseDate"
              onChange={handleDateChange}
              max={currentDate}
              disabled={loading}
              required
            />
          </div>
        </div>
        <div className="mb-3 row">
          <label htmlFor="amount" className="col-sm-3 col-form-label text-end">
            * Amount ($):
          </label>
          <div className="col-sm-6">
            <input
              type="number"
              className="form-control"
              id="amount"
              min={0}
              placeholder="20.5"
              step="0.01" // Allow decimal values
              onChange={handleAmountChange}
              disabled={loading}
              required
            />
          </div>
        </div>

        <div className="mb-3 row">
          <label
            htmlFor="description"
            className="col-sm-3 col-form-label text-end"
          >
            Description:
          </label>
          <div className="col-sm-6">
            <input
              type="text"
              className="form-control"
              id="description"
              placeholder="Paid with credit card"
              onChange={handleDescriptionChange}
              disabled={loading}
            />
          </div>
        </div>

        <div className="d-grid gap-2 col-sm-6 mx-auto">
          <button
            type="submit"
            className="btn"
            style={buttonStyle}
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
            disabled={loading}
          >
            {loading ? (
              <div className="spinner-border" role="status">
                <span className="visually-hidden">Loading...</span>
              </div>
            ) : (
              "Add Expense"
            )}
          </button>
          <button
            type="button"
            className="btn btn-outline-secondary"
            onClick={handleCancel}
            disabled={loading}
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
};

export default AddExpenseForm;
