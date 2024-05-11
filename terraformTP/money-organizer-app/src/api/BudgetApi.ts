import { Budget} from "@/types/Interfaces";

const baseUrl = import.meta.env.VITE_API_BASE_URL + '/budgets'

export const BudgetApi = {

    async getBudgets(token?: string): Promise<Budget[]> {
        const response = await fetch(baseUrl,
            {
                method: 'GET',
                headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token,
                },
            });
        const data = await response.json();
        return data as Budget[];
    },
    
    async createBudget(newBudget: Budget,token?: string) {
        const response = await fetch(baseUrl, {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token,
            },
            body: JSON.stringify(newBudget),
        });
        console.log("out")
        const data = await response.json();
        console.log("data", data)
        return data as Budget;
    },
    
    async updateBudget(updatedBudget: Budget,token?: string) {
        const response = await fetch(baseUrl, {
            method: 'PUT',
            headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token,
            },
            body: JSON.stringify(updatedBudget),
        });
        const data = await response.json();
        return data as Budget;
    },
    
    async deleteBudget(BudgetId: string | undefined,token?: string) {
        const response = await fetch(baseUrl, {
            method: 'DELETE',
            headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token,
            },
            body: JSON.stringify({"id": BudgetId}),
        });
        const data = await response.json();
        return data;
    }
}