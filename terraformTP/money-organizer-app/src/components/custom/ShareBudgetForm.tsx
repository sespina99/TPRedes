import { useState, FormEvent } from "react";
import { toast } from "@/components/ui/use-toast.ts";
import { useNavigate } from "react-router-dom";
import { useAuthStore } from "@/hooks/useAuthStore";
import { Budget } from "@/types/Interfaces";
import { SubscriberApi } from "@/api/SubscriberApi";

interface Props {
  budget: Budget;
}

const ShareBudgetForm = ({ budget }: Props) => {
  const { token } = useAuthStore();

  const [email, setEmail] = useState("");
  const navigate = useNavigate();

  const [isHovered, setIsHovered] = useState(false);

  const handleMouseEnter = () => {
    setIsHovered(true);
  };

  const handleMouseLeave = () => {
    setIsHovered(false);
  };

  const [loading, setLoading] = useState(false);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setLoading(true);

    if (token) {
      const subscriptionSuccess = await SubscriberApi.subscribeToBudget(
        budget.id,
        email,
        token
      );

      if (subscriptionSuccess) {
        toast({
          title: "Successful sharing",
          description:
            "Budget with name = " +
            budget.name +
            " successfully shared to email = " +
            email,
        });
        setLoading(false);
        navigate("/my-budgets");
      } else {
        toast({
          title: "Sharing failed",
          description:
            "There was an error sharing the budget with name = " +
            budget.name +
            " to email = " +
            email,
        });
        setLoading(false);
      }
    }
  };

  const buttonStyle = {
    backgroundColor: isHovered ? "#004080" : "#007bff", // Set the primary background color
    color: "#fff", // Set text color
  };

  return (
    <>
      <div className="container mt-4">
        <h2 className="text-4xl font-bold text-gray-800 mt-4 mb-4 underline">
          Share Budget
        </h2>
        <h3 className="mb-2">
          <b>Name =</b> {budget.name}
        </h3>
        <form onSubmit={handleSubmit}>
          <div className="mb-3 row">
            <label htmlFor="email" className="col-sm-3 col-form-label text-end">
              Email
            </label>
            <div className="col-sm-6">
              <input
                value={email}
                onChange={(event) => setEmail(event.target.value)}
                type="email"
                className="form-control"
                id="email"
                required
              ></input>
            </div>
          </div>
          <div className="d-grid gap-2 col-sm-6 mx-auto">
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
                  "Share"
                )}
              </button>
            </div>
          </div>
        </form>
      </div>
    </>
  );
};

export default ShareBudgetForm;
