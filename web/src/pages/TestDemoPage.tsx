import {Button} from "@/components/ui/Button";
import {Input} from "@/components/ui/Input";
import {Logo} from "@/components/ui/Logo";
import {ExampleErrorFlow} from "@/components/examples/ExampleErrorFlow";
import {ExampleEditForm} from "@/components/examples/ExampleEditForm";

function TestDemoPage() {
    return (
        <div className="flex flex-col justify-between gap-2">
            <div className="flex justify-center">Home page</div>

            <div className="flex flex-row justify-center gap-2">
                <Button onClick={undefined}>Save</Button>
                <Button variant="secondary">Cancel</Button>
                <Button variant="tertiary">Back</Button>
                <Button variant="ghost">Loading…</Button>
            </div>

            <div className="flex flex-row justify-center gap-2">
                <Input
                    label="Email"
                    type="email"
                    name="email"
                    value={undefined}
                    onChange={undefined}
                    error={undefined}
                    helperText="We’ll never share your email."
                />
            </div>

            <div className="flex flex-row justify-center gap-2">
                <ExampleEditForm/>
            </div>

            <div className="flex flex-row justify-center gap-2">
                <Logo/>
            </div>

            <div className="flex flex-row justify-center gap-2">
                <ExampleErrorFlow/>
            </div>
        </div>
    );
}

export default TestDemoPage;