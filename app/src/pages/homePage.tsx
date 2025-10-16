export default function HomePage() {
  return (
    <div className="flex flex-col items-center justify-center min-h-[80vh] text-center">
      <h1 className="text-5xl font-bold mb-4 text-gray-800">
        Welcome to <span className="text-indigo-600">DataNaut</span>
      </h1>
      <p className="text-lg text-gray-600 max-w-2xl">
        Upload, analyze, and visualize your data easily. <br />
        Start exploring insights in just a few clicks.
      </p>
    </div>
  );
}
