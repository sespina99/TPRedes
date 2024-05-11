import { useState, FormEvent, useEffect } from "react";
import { useRegister } from "@/hooks/useCognito.ts";
import { toast } from "@/components/ui/use-toast.ts";
import { useNavigate } from "react-router-dom";

const SignUpForm = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [registerUser, result, error] = useRegister();

  const navigate = useNavigate();

  const redirectTimeOut = 2;

  const [isHovered, setIsHovered] = useState(false);

  const handleMouseEnter = () => {
    setIsHovered(true);
  };

  const handleMouseLeave = () => {
    setIsHovered(false);
  };

  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!error) return;
    setLoading(false);
    toast({
      title: "Error registering",
      description: error.message,
    });
  }, [error]);

  useEffect(() => {
    if (!result) return;
    setLoading(false);
    toast({
      title: "User registered successfully",
      description: "Check your email to confirm your user",
    });
    setTimeout(() => {
      navigate("/login");
    }, 1000 * redirectTimeOut);
  }, [result]);

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setLoading(true);

    const data = { email, password };

    registerUser(data);
  };

  const buttonStyle = {
    backgroundColor: isHovered ? "#004080" : "#007bff", // Set the primary background color
    color: "#fff", // Set text color
  };

  return (
    <>
      <div className="container mt-4">
        <h2 className="text-4xl font-bold text-gray-800 mt-4 mb-4 underline">
          Sign up
        </h2>
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
                disabled={loading}
                required
              ></input>
            </div>
          </div>
          <div className="mb-3 row">
            <label htmlFor="email" className="col-sm-3 col-form-label text-end">
              Password
            </label>
            <div className="col-sm-6">
              <input
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                className="form-control"
                id="password"
                type="password"
                disabled={loading}
                required
              ></input>
            </div>
          </div>
          <div className="d-grid gap-2 col-sm-6 mx-auto">
            <div className="d-grid gap-2 col-sm-6 mx-auto">
              <button
                type="submit"
                value="Login"
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
                  "Sign up"
                )}
              </button>
            </div>
          </div>
        </form>
      </div>
    </>
  );
};

export default SignUpForm;
