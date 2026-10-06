const noteText = document.getElementById("note-text");
const charCount = document.getElementById("char-count");
const wordCount = document.getElementById("word-count");
const clearBtn = document.getElementById("clear-btn");
const themeToggle = document.getElementById("theme-toggle");

function updateCounts() {
    const text = noteText.value;
    const characters = text.length;

    const words = text.trim() === ""
        ? 0
        : text.trim().split(/\s+/).length;

    charCount.textContent = `${characters} / 200 characters`;
    wordCount.textContent = `${words} words`;

    charCount.classList.remove("warning", "over");

    if (characters > 200) {
        charCount.classList.add("over");
    } else if (characters > 180) {
        charCount.classList.add("warning");
    }
}
noteText.addEventListener("input", function () {
    updateCounts();
    localStorage.setItem("draft", noteText.value);
});

function clearNote() {
    noteText.value = "";
    updateCounts();
    localStorage.removeItem("draft");
}

clearBtn.addEventListener("click", clearNote);

noteText.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        clearNote();
    }
});

themeToggle.addEventListener("click", function () {
    document.body.classList.toggle("dark");

    const isDark = document.body.classList.contains("dark");

    themeToggle.textContent = isDark ? "Light mode" : "Dark mode";

    localStorage.setItem("theme", isDark ? "dark" : "light");
});

const savedDraft = localStorage.getItem("draft");

if (savedDraft !== null) {
    noteText.value = savedDraft;
}

const savedTheme = localStorage.getItem("theme");

if (savedTheme === "dark") {
    document.body.classList.add("dark");
    themeToggle.textContent = "Light mode";
}

updateCounts();