import { Expense } from "@/types/Interfaces";


const baseUrl = import.meta.env.VITE_API_BASE_URL + '/expenses'

function compareByDateDescending(a: Expense, b: Expense): number {
    return b.date - a.date;
  }

export const expenseApi = {
    
    async getExpenses(token?: string): Promise<Expense[]> {
        const response = await fetch(baseUrl,
            {
                method: 'GET',
                headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token,
                },
            });
        const data = await response.json();
        const expenses: Expense[] = data as Expense[];
        expenses.forEach(expense => {
            expense.amount = Number(expense.amount) / 100.0
        });

        expenses.sort(compareByDateDescending)
        
        return expenses;
    },
    
    async createExpense(newExpense: Expense, token: string) {
        newExpense.amount = Number(newExpense.amount * 100)
          const response = await fetch(baseUrl, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ' + token
            },
            body: JSON.stringify(newExpense),
          });
      
          const data = await response.json();
          return data as Expense;
      },
    
    async updateExpense(updatedExpense: Expense,token?: string) {
        updatedExpense.amount = Number(updatedExpense.amount *100)
        const response = await fetch(baseUrl, {
            method: 'PUT',
            headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token 
            },
            body: JSON.stringify(updatedExpense),
        });
        const data = await response.json();
        return data as Expense;
    },
    
    async deleteExpense(expenseId: string,token?: string) {
        const response = await fetch(baseUrl, {
            method: 'DELETE',
            headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token 
            },
            body: JSON.stringify({"id": expenseId}),
        });
        const data = await response.json();
        return data;
    }
}