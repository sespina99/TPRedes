import { FormEvent, useState } from "react";

import { BudgetApi } from "@/api/BudgetApi";
import { useNavigate } from "react-router-dom";
import { toast } from "@/components/ui/use-toast.ts";
import { useAuthStore } from "@/hooks/useAuthStore";

const AddBudgetForm = () => {
  const { token } = useAuthStore();
  const navigate = useNavigate();

  const [name, setName] = useState("");

  const handleNameChange = (e: any) => {
    setName(e.target.value);
  };

  const [pdfFile, setPdfFile] = useState(null); // State to store the selected PDF file

  const [loading, setLoading] = useState(false);

  const [isHovered, setIsHovered] = useState(false);

  const handleMouseEnter = () => {
    setIsHovered(true);
  };

  const handleMouseLeave = () => {
    setIsHovered(false);
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

  const handleAddBudget = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setLoading(true);
    if (pdfFile) {
      const pdfString = await convertPdfToBase64(pdfFile);
      const budget = {
        name,
        budget_file: pdfString as string,
      };
      try {
        BudgetApi.createBudget(
          {
            ...budget,
          },
          token ?? ""
        ).then(() => {
          toast({
            title: `Budget Created`,
            description: `Budget with name = ${budget.name} created succesfully`,
          });
          navigate("/my-budgets");
        })
        .catch(() => {
          toast({
            title: `Error creating budget`,
            description: `Error during creating budget. Probably because the pdf is too large`,
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
    navigate("/my-budgets"); // Change the route as needed
  };

  return (
    <div className="container mt-4">
      <h2 className="text-4xl font-bold text-gray-800 mt-4 mb-4 underline">
        Add Budget
      </h2>
      <form onSubmit={handleAddBudget}>
        <div className="mb-3 row">
          <label htmlFor="name" className="col-sm-3 col-form-label text-end">
            * Budget Name:
          </label>
          <div className="col-sm-6">
            <input
              type="text"
              className="form-control"
              id="description"
              placeholder="Gym Budget"
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
              required
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
              "Add Budget"
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

export default AddBudgetForm;
