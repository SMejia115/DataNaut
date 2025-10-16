import { Link, useLocation } from "react-router-dom";

export default function Navbar() {
  const location = useLocation();

  const links = [
    { path: "/", label: "Home" },
    { path: "/upload", label: "Upload" },
    { path: "/dashboard", label: "Dashboard" },
  ];

  return (
    <nav className="bg-white shadow-md border-b border-gray-200">
      <div className="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
        <h1 className="text-xl font-bold text-indigo-600">DataNaut 🚀</h1>
        <ul className="flex gap-6 text-gray-700">
          {links.map((link) => (
            <li key={link.path}>
              <Link
                to={link.path}
                className={`hover:text-indigo-600 transition-colors ${
                  location.pathname === link.path ? "text-indigo-600 font-semibold" : ""
                }`}
              >
                {link.label}
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </nav>
  );
}
