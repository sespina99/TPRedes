const baseUrl = import.meta.env.VITE_API_BASE_URL + '/subscriber'

export const SubscriberApi = {

    async subscribeToBudget(budgetId: string | undefined, email: string, token?: string): Promise<boolean> {
        
        const inputBody = {
            id: budgetId,
            emails: [email]
        }
        
        const response = await fetch(baseUrl,
            {
                method: 'POST',
                headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token,
                },
                body: JSON.stringify(inputBody),
            });

        return response.status === 201
    },
    
}