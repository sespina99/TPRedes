import { useState, FormEvent, useEffect } from "react";
import { useLogin } from "@/hooks/useCognito.ts";
import { toast } from "@/components/ui/use-toast.ts";
import { useNavigate } from "react-router-dom";
import { Link } from "react-router-dom";

const LoginForm = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [login, result, error] = useLogin();
  const navigate = useNavigate();

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
      title: "Error doing login",
      description: error.message,
    });
  }, [error]);

  useEffect(() => {
    if (!result) return;
    toast({
      title: "Login successful",
      description: "Login made successfully",
    });
    navigate("/");
    return;
  }, [result]);

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setLoading(true);
    const data = { email, password };

    login(data);
  };

  const buttonStyle = {
    backgroundColor: isHovered ? "#004080" : "#007bff", // Set the primary background color
    color: "#fff", // Set text color
  };

  return (
    <>
      <div className="container mt-4">
        <h2 className="text-4xl font-bold text-gray-800 mt-4 mb-4 underline">
          Login
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
                  "Login"
                )}
              </button>
            </div>
          </div>
        </form>
        <p>
          Don't have an account ?{" "}
          <Link
            style={{
              color: "blue",
              textDecoration: "underline",
              cursor: "pointer",
            }}
            to="/sign-up"
          >
            Sign up
          </Link>
        </p>
      </div>
    </>
  );
};

export default LoginForm;
