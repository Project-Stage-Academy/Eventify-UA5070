import { useState } from "react";
import { Button } from "@/components/ui/Button";
import { ErrorPopup } from "@/components/ui/ErrorPopup";

// Temporary example object
export function ExampleErrorFlow() {
    const [errorOpen, setErrorOpen] = useState(false);

    const handleAction = async () => {
        try {
            throw new Error("Something bad happened");
        } catch (e) {
            setErrorOpen(true);
        }
    };

    return (
        <>
            <Button variant="primary" onClick={handleAction}>
                Do something risky
            </Button>

            <ErrorPopup
                open={errorOpen}
                onClose={() => setErrorOpen(false)}
                title="Something went wrong"
                message="We couldn’t complete your request. Please try again."
                actions={
                    <button
                        type="button"
                        className="text-xs font-medium text-red-700 underline underline-offset-2"
                        onClick={() => {
                            setErrorOpen(false);
                        }}
                    >
                        View details
                    </button>
                }
            />
        </>
    );
}
