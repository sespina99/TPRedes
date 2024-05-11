import { FileResponse} from "@/types/Interfaces";

const baseUrl = import.meta.env.VITE_API_BASE_URL + '/budget_file'


export const BudgetFileApi = {

    async getBudgetFile(budgetId: string | undefined, token?: string): Promise<FileResponse> {
        
        const inputBody = {
            id: budgetId
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

        let fileResponse: FileResponse = {
            file: undefined,
            error_message: undefined
        }

        //Parse the response and check status code
        const data = await response.json();

        //403 (Budget not exists or current user doesn't have permission to see it)
        if(response.status === 403){
            fileResponse.error_message = data
        }
        //200 (success)
        else if(response.status === 200){
            fileResponse.file = data.file
        }
        //500
        else{
            fileResponse.error_message = 'Error getting PDF'
        }

        return fileResponse;
    },

    async revertBudgetFile(budgetId: string | undefined, token?: string) {
        
        const inputBody = {
            id: budgetId
        }
        
        const response = await fetch(baseUrl,
            {
                method: 'PUT',
                headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token,
                },
                body: JSON.stringify(inputBody),
            });

        //Parse the response and check status code
        const data = await response.json();


        return data;
    }
}