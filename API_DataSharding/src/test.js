const text = "http://localhost:5000/api/scrape";

console.info(text.split(":")[2].split("/", 1)[0])