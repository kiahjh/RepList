import { createFileRoute } from "@tanstack/solid-router";
import { CheckIcon, LoaderCircleIcon } from "lucide-solid";
import { Component, createSignal, onMount } from "solid-js";

export const Route = createFileRoute("/confirm-email")({
  component: () => <ConfirmEmail />,
});

const ConfirmEmail: Component = () => {
  let [loading, setLoading] = createSignal(true);
  let [error, setError] = createSignal<string | null>(null);
  let [success, setSuccess] = createSignal(false);

  onMount(async () => {
    let searchParams = new URLSearchParams(window.location.search);
    let id = searchParams.get("waitlist_id");
    if (!id) {
      window.location.href = "/";
    }
    let res = await fetch(
      `${import.meta.env.VITE_API_ENDPOINT}/confirm-waitlist-email`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: `"${id}"`,
      },
    );
    let json = await res.json();
    let succeeded = json.type === "success";
    if (!succeeded) {
      setError(json.message);
    }
    setLoading(false);
    setSuccess(succeeded);
  });

  return (
    <div class="bg-primary-100 h-screen w-screen flex justify-center items-center">
      {loading() && (
        <LoaderCircleIcon class="text-primary-800 animate-spin size-10" />
      )}
      {error() && (
        <div class="border-red-300/70 border rounded-3xl p-8 bg-red-500/10 shadow-xl shadow-red-700/15 text-lg max-w-xs text-center text-red-700">
          {error()}
        </div>
      )}
      {success() && (
        <div class="border-primary-300/70 border rounded-3xl p-8 bg-primary-500/10 shadow-xl shadow-primary-700/15 text-lg max-w-xs text-center text-primary-700 flex flex-col items-center gap-4">
          <div class="size-10 bg-primary-500/20 rounded-full p-2">
            <CheckIcon />
          </div>
          <p>
            You're on the list! We'll let you know when you can start using
            RepList.
          </p>
        </div>
      )}
    </div>
  );
};
