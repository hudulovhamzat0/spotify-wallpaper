#!/usr/bin/env python3
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import subprocess
import os
import threading
import signal
import psutil

class SpotifyWallpaperController:
    def __init__(self, root):
        self.root = root
        self.root.title("Spotify Wallpaper Controller")
        self.root.geometry("500x400")
        self.root.resizable(False, False)
        
        # Variables
        self.script_process = None
        self.script_running = False
        self.current_folder = tk.StringVar(value="./anime")
        
        # Get script directory
        self.script_dir = os.path.dirname(os.path.abspath(__file__))
        self.run_script_path = os.path.join(self.script_dir, "run.sh")
        
        self.setup_ui()
        # Check initial folder state
        self.update_status()
    
    def setup_ui(self):
        # Main frame
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Title
        title_label = ttk.Label(main_frame, text="Spotify Wallpaper Controller", 
                               font=("Arial", 16, "bold"))
        title_label.grid(row=0, column=0, columnspan=2, pady=(0, 20))
        
        # Script Control Section
        control_frame = ttk.LabelFrame(main_frame, text="Script Control", padding="10")
        control_frame.grid(row=1, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 15))
        
        # Start/Stop buttons
        button_frame = ttk.Frame(control_frame)
        button_frame.grid(row=0, column=0, columnspan=2, pady=(0, 10))
        
        self.start_button = ttk.Button(button_frame, text="Start Script", 
                                      command=self.start_script, style="Accent.TButton")
        self.start_button.pack(side=tk.LEFT, padx=(0, 10))
        
        self.stop_button = ttk.Button(button_frame, text="Stop Script", 
                                     command=self.stop_script, state="disabled")
        self.stop_button.pack(side=tk.LEFT)
        
        # Status
        self.status_label = ttk.Label(control_frame, text="Status: Stopped", 
                                     foreground="red")
        self.status_label.grid(row=1, column=0, columnspan=2, pady=(5, 0))
        
        # Anime Settings Section
        anime_frame = ttk.LabelFrame(main_frame, text="Anime Folder Settings", padding="10")
        anime_frame.grid(row=2, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 15))
        
        # Folder selection
        folder_label = ttk.Label(anime_frame, text="Photo Folder: (If u dont want select empty folder)",)
        folder_label.grid(row=0, column=0, sticky=tk.W, pady=(0, 5))
        
        self.folder_display = ttk.Label(anime_frame, textvariable=self.current_folder, 
                                       foreground="blue", cursor="hand2")
        self.folder_display.grid(row=1, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        self.folder_display.bind("<Button-1>", lambda e: self.select_folder())
        
        folder_button = ttk.Button(anime_frame, text="Browse Folder", 
                                  command=self.select_folder)
        folder_button.grid(row=1, column=1, sticky=tk.E, padx=(10, 0))
        
        # Info label
        info_label = ttk.Label(anime_frame, text="Tip: Select an empty folder to disable anime characters",
                              font=("Arial", 9), foreground="gray")
        info_label.grid(row=2, column=0, columnspan=2, sticky=tk.W, pady=(5, 0))
        
        # Configure grid weights
        main_frame.columnconfigure(0, weight=1)
        control_frame.columnconfigure(0, weight=1)
        anime_frame.columnconfigure(0, weight=1)
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
    
    def start_script(self):
        """Start the wallpaper script"""
        if not os.path.exists(self.run_script_path):
            messagebox.showerror("Error", f"run.sh not found at: {self.run_script_path}")
            return
        
        try:
            # Make sure script is executable
            os.chmod(self.run_script_path, 0o755)
            
            # Start the script in background
            self.script_process = subprocess.Popen(
                [self.run_script_path],
                cwd=self.script_dir,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                preexec_fn=os.setsid  # Create new process group
            )
            
            self.script_running = True
            self.start_button.config(state="disabled")
            self.stop_button.config(state="normal")
            self.status_label.config(text="Status: Running", foreground="green")
            
            # Start monitoring thread
            threading.Thread(target=self.monitor_script, daemon=True).start()
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to start script: {str(e)}")
    
    def stop_script(self):
        """Stop the wallpaper script"""
        if self.script_process:
            try:
                # Kill the entire process group
                os.killpg(os.getpgid(self.script_process.pid), signal.SIGTERM)
                self.script_process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                # Force kill if it doesn't terminate gracefully
                os.killpg(os.getpgid(self.script_process.pid), signal.SIGKILL)
            except ProcessLookupError:
                # Process already terminated
                pass
            except Exception as e:
                print(f"Error stopping script: {e}")
        
        # Also kill any remaining bash processes running the script
        try:
            for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
                if proc.info['name'] == 'bash' and proc.info['cmdline']:
                    cmdline = ' '.join(proc.info['cmdline'])
                    if 'run.sh' in cmdline or 'spotify_wallpaper' in cmdline:
                        proc.kill()
        except:
            pass
        
        self.script_process = None
        self.script_running = False
        self.start_button.config(state="normal")
        self.stop_button.config(state="disabled")
        self.status_label.config(text="Status: Stopped", foreground="red")
    
    def monitor_script(self):
        """Monitor if script is still running"""
        while self.script_running and self.script_process:
            if self.script_process.poll() is not None:
                # Script has terminated
                self.root.after(0, self.on_script_terminated)
                break
            threading.Event().wait(1)  # Check every second
    
    def on_script_terminated(self):
        """Called when script terminates unexpectedly"""
        self.script_running = False
        self.script_process = None
        self.start_button.config(state="normal")
        self.stop_button.config(state="disabled")
        self.status_label.config(text="Status: Stopped", foreground="red")
    

    def select_folder(self):
        """Open folder selection dialog"""
        folder = filedialog.askdirectory(
            title="Select Anime Characters Folder (or empty folder to disable)",
            initialdir=self.current_folder.get()
        )
        
        if folder:
            self.current_folder.set(folder)
            # Verify folder and show status
            image_files = []
            try:
                for file in os.listdir(folder):
                    if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                        image_files.append(file)
                
                if image_files:
                    messagebox.showinfo("Success", 
                                      f"Found {len(image_files)} image files in selected folder")
                else:
                    messagebox.showinfo("Info", 
                                      "Empty folder selected - anime characters will be disabled")
            except Exception as e:
                messagebox.showerror("Error", f"Cannot access folder: {str(e)}")
            
            self.update_status()
    def update_status(self):
        """Update the current folder display"""
        if os.path.exists(self.current_folder.get()):
            try:
                files = [f for f in os.listdir(self.current_folder.get()) 
                        if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
                count = len(files)
                if count > 0:
                    self.folder_display.config(foreground="green")
                else:
                    self.folder_display.config(foreground="orange")  # Empty folder = no anime
            except:
                self.folder_display.config(foreground="red")
        else:
            self.folder_display.config(foreground="red")
    
    def on_closing(self):
        """Handle window closing"""
        if self.script_running:
            if messagebox.askokcancel("Quit", "Script is still running. Stop it before closing?"):
                self.stop_script()
                self.root.destroy()
        else:
            self.root.destroy()

def main():
    root = tk.Tk()
    app = SpotifyWallpaperController(root)
    
    # Handle window closing
    root.protocol("WM_DELETE_WINDOW", app.on_closing)
    
    # Apply modern styling
    style = ttk.Style()
    try:
        style.theme_use('clam')  # Modern looking theme
    except:
        pass
    
    root.mainloop()

if __name__ == "__main__":
    main()