import { createFileRoute } from "@tanstack/solid-router";
import { Component, createEffect, createSignal } from "solid-js";
import { ArrowRightIcon } from "lucide-solid";
import cx from "clsx";
import AppIcon from "/app-icon.jpg";

export const Route = createFileRoute("/")({
  component: () => <Home />,
});

const Home: Component = () => {
  const [email, setEmail] = createSignal("");
  const [emailIsValid, setEmailIsValid] = createSignal(false);
  const [error, setError] = createSignal<string | null>(null);
  const [succeeded, setSucceeded] = createSignal(false);

  createEffect(() => {
    setEmailIsValid(email().includes("@"));
  });

  return (
    <div class="h-screen w-screen bg-primary-100 flex flex-col">
      <div class="flex-grow flex flex-col items-center justify-center">
        <img
          src={AppIcon}
          class="size-20 rounded-2xl shadow-xl shadow-primary-600/50"
        />
        <h1 class="text-4xl font-inria font-bold text-primary-900 mb-3 mt-8">
          RepList
        </h1>
        <p class="text-lg text-primary-800/70 font-inria max-w-xs text-center mb-12 leading-6">
          The collaborative tool for musicians that actually practice
        </p>
        <div class="relative w-screen h-40 flex flex-col items-center">
          <div
            class={cx(
              "border-red-300/70 border rounded-3xl p-8 bg-red-500/10 shadow-xl shadow-red-700/15 text-lg max-w-xs text-center text-red-700 transition-[opacity,filter,scale] duration-200 absolute",
              !error() && "opacity-0 blur scale-90 pointer-events-none",
            )}
          >
            {error()}
          </div>
          <div
            class={cx(
              "border-primary-300/70 border rounded-3xl p-8 bg-primary-500/10 shadow-xl shadow-primary-700/15 text-lg max-w-xs text-center text-primary-700 transition-[opacity,filter,scale] duration-200 absolute",
              !succeeded() && "opacity-0 blur scale-90 pointer-events-none",
            )}
          >
            Check your email for a confirmation link!
          </div>
          <div
            class={cx(
              "flex flex-col items-center transition-[opacity,filter,scale] duration-200 absolute",
              (succeeded() || error()) &&
                "opacity-0 blur scale-90 pointer-events-none",
            )}
          >
            <p class="text-base text-primary-800/70 font-inria max-w-xs text-center mb-2">
              Get on the waitlist for early access:
            </p>
            <form
              class="bg-white flex items-center p-1.5 shadow-xl shadow-primary-300/30 rounded-[16px]"
              onSubmit={async (e) => {
                e.preventDefault();
                let res = await fetch(
                  "https://api.replist.innocencelabs.com/join-waitlist",
                  {
                    method: "POST",
                    headers: {
                      "Content-Type": "application/json",
                    },
                    body: JSON.stringify(email()),
                  },
                );
                var json = await res.json();
                if (json.type !== "success" && json.type !== "failure") {
                  setError("An unknown error occurred");
                  return;
                }
                if (json.type === "failure") {
                  setError(json.message ?? "An unknown error occurred");
                  return;
                }
                setSucceeded(true);
              }}
            >
              <input
                value={email()}
                onInput={(e) => setEmail(e.currentTarget.value)}
                class="h-full px-4 w-72 sm:w-88 text-lg sm:text-xl outline-none placeholder:text-zinc-300"
                placeholder="django@example.com"
              />
              <button
                type="submit"
                class={cx(
                  "bg-black flex items-center justify-center size-12 rounded-xl group transition-transform duration-200",
                  !emailIsValid()
                    ? "opacity-20 cursor-not-allowed"
                    : "cursor-pointer active:scale-95",
                )}
                disabled={!emailIsValid()}
              >
                <ArrowRightIcon
                  class={cx(
                    "text-white size-7",
                    emailIsValid() &&
                      `group-hover:scale-110 group-hover:translate-x-1 transition-transform duration-200`,
                  )}
                />
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};
