export interface User {
    id: string;
    email: string;
    password?: string;
    hashed_password: string;
    current_password?: string;
    confirmed_at: Date | null;
    inserted_at: Date;
    updated_at: Date;
}