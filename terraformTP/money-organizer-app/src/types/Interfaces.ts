export interface Expense {
    date: number;
    category: string;
    amount: number;
    description: string;
    name: string;
    id?: string;
    bill_file?: string;
    has_pdf?: boolean
}

export interface Budget {
    link?: string;
    id?: string;
    budget_file?: string;
    name: string;
    subscribers?: string[]
}

export interface FileResponse {
    file?: string;
    error_message?: string;
}