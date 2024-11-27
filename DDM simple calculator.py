import tkinter as tk
from tkinter import messagebox

def calculate_ddm():
    try:
        d1 = float(entry_dividend.get())
        r = float(entry_rate.get()) / 100
        g = float(entry_growth.get()) / 100
        
        if r <= g:
            messagebox.showerror("Input Error", "Required return must be greater than the growth rate.")
            return
        
        price = d1 / (r - g)
        label_result.config(text=f"Stock Price: ${price:.2f}")
    except ValueError:
        messagebox.showerror("Input Error", "Please enter valid numerical values.")

# Create GUI
root = tk.Tk()
root.title("Dividend Discount Model Calculator")

# Input Fields
tk.Label(root, text="Expected Dividend (D1):").grid(row=0, column=0, padx=10, pady=5, sticky="e")
entry_dividend = tk.Entry(root)
entry_dividend.grid(row=0, column=1, padx=10, pady=5)

tk.Label(root, text="Required Rate of Return (r %):").grid(row=1, column=0, padx=10, pady=5, sticky="e")
entry_rate = tk.Entry(root)
entry_rate.grid(row=1, column=1, padx=10, pady=5)

tk.Label(root, text="Dividend Growth Rate (g %):").grid(row=2, column=0, padx=10, pady=5, sticky="e")
entry_growth = tk.Entry(root)
entry_growth.grid(row=2, column=1, padx=10, pady=5)

# Calculate Button
btn_calculate = tk.Button(root, text="Calculate Stock Price", command=calculate_ddm)
btn_calculate.grid(row=3, column=0, columnspan=2, pady=10)

# Result Display
label_result = tk.Label(root, text="Stock Price: $0.00", font=("Arial", 14))
label_result.grid(row=4, column=0, columnspan=2, pady=10)

# Run the application
root.mainloop()
