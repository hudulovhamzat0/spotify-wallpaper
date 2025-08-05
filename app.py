import tkinter as tk
from tkinter import filedialog, messagebox
import subprocess
import os

# 🌍 Global variables
selected_folder = None
process = None

def browse_folder():
    global selected_folder
    folder_path = filedialog.askdirectory(title="Select Folder")

    if folder_path:
        selected_folder = os.path.abspath(folder_path)
        label_selected.config(text=f"Selected folder:\n{selected_folder}")
        print(f">> Folder selected: {selected_folder}")
    else:
        selected_folder = None
        label_selected.config(text="❌ No folder selected")

def start():
    global process
    if include_photos_var.get():
        if not selected_folder:
            return messagebox.showwarning("No folder selected", "Please select a folder first.")

        try:
            print(f">> Running: bash run.sh -p \"{selected_folder}\"")
            process = subprocess.Popen(["bash", "run.sh", "-p", selected_folder])
        except Exception as e:
            messagebox.showerror("Error", f"Could not start:\n{e}")
    else:
        try:
            print(f">> Running: bash run.sh -x script/x.sh")
            process = subprocess.Popen(["bash", "run.sh", "-x", "script/x.sh"])
        except Exception as e:
            messagebox.showerror("Error", f"Could not start:\n{e}")

def stop():
    global process
    if process and process.poll() is None:
        try:
            process.terminate()
            process.wait()
            print(">> Process stopped.")
        except Exception as e:
            messagebox.showerror("Error", f"Could not stop:\n{e}")
    else:
        print(">> No active process.")
        messagebox.showinfo("Status", "No running process to stop.")

# 🖼️ GUI setup
root = tk.Tk()
root.title("Spotify Wallpaper Control")
root.geometry("400x320")
root.resizable(False, False)

# ▶️ Start button
start_button = tk.Button(
    root,
    text="Start",
    command=start,
    width=20,
    height=2,
    bg="#28a745",
    fg="white"
)
start_button.pack(pady=15)

# ⏹️ Stop button
stop_button = tk.Button(
    root,
    text="Stop",
    command=stop,
    width=20,
    height=2,
    bg="#dc3545",
    fg="white"
)
stop_button.pack(pady=5)

# ✅ Checkbox: Include photos
include_photos_var = tk.BooleanVar(value=True)
include_photos_check = tk.Checkbutton(
    root,
    text="Include photos",
    variable=include_photos_var,
    font=("Arial", 10)
)
include_photos_check.pack(pady=10)

# 🏷️ Selected folder label
label_selected = tk.Label(root, text="Selected folder: None", font=("Arial", 10), wraplength=360)
label_selected.pack(pady=10)

# 📁 Folder select button (bottom)
browse_button = tk.Button(
    root,
    text="Select Folder",
    command=browse_folder,
    width=20,
    height=2,
    bg="#007bff",
    fg="white"
)
browse_button.pack(pady=10)

root.mainloop()
