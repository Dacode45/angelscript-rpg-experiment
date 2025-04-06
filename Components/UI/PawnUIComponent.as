event void FOnPercentChangedEvent(float Changed);

class UPawnUIComponent : UActorComponent
{
	UPROPERTY()
	float LastCurrentHealthPerc;

	UPROPERTY()
	FOnPercentChangedEvent OnCurrentHealthChanged;

	UFUNCTION()
	void SetCurrentHealthChange(float Changed) {
		LastCurrentHealthPerc = Changed;
		OnCurrentHealthChanged.Broadcast(Changed);
	}
};