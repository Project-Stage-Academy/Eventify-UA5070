import {Button} from "@/components/ui/Button.tsx";
import {Modal} from "@/components/ui/Modal.tsx";
import {Input} from "@/components/ui/Input.tsx";
import {useState} from "react";

export function ExampleEditForm() {
    const [open, setOpen] = useState(false);

    return (
        <>
            <Button variant="secondary" onClick={() => setOpen(true)}>
                Open edit modal
            </Button>

            <Modal
                open={open}
                onClose={() => setOpen(false)}
                title="Edit profile"
            >
                <form className="flex flex-col gap-4">
                    <Input label="Name" name="name" />
                    <Input label="Email" type="email" name="email" />

                    <div className="mt-2 flex justify-end gap-2">
                        <Button
                            variant="secondary"
                            type="button"
                            onClick={() => setOpen(false)}
                        >
                            Cancel
                        </Button>
                        <Button
                            variant="primary"
                            type="submit"
                            onClick={() => setOpen(false)}
                        >
                            Save
                        </Button>
                    </div>
                </form>
            </Modal>
        </>
    )
}