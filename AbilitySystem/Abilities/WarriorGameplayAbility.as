UENUM()
enum EWarriorAbilityActivationPolicy
{
	OnGiven,
	OnTriggered
}

class UWarriorGameplayAbility : UAngelscriptGASAbility
{
	UPROPERTY()
	EWarriorAbilityActivationPolicy ActivationPolicy = EWarriorAbilityActivationPolicy::OnGiven;

	void OnGiveAbility(FGameplayAbilityActorInfo AI, FGameplayAbilitySpec AS) {
		if (ActivationPolicy == EWarriorAbilityActivationPolicy::OnGiven)
		{
			if (AS.IsActive())
			{
				ActorInfo.AbilitySystemComponent.TryActivateAbility(AS.Handle);
			}
		}
	}

	UFUNCTION(BlueprintOverride)
	void OnEndAbility(bool bWasCancelled)
	{
		if (ActivationPolicy == EWarriorAbilityActivationPolicy::OnGiven)
		{
			// ActorInfo.AbilitySystemComponent.ClearAbility(Handle);
		}
		// ability
	}

	// UFUNCTION(BlueprintOverride)
	// void OnEndAbility(FGameplayAbilitySpecHandle AH, FGameplayAbilityActorInfo AI, FGameplayAbilityActivationInfo ActivationInfo, bool bReplicateEndAbility, bool bWasCancelled)

	// Helpers
	UWarriorAbilitySystemComponent GetWarriorAbilitySystemComponentFromActorInfo() {
		return Cast<UWarriorAbilitySystemComponent>(ActorInfo.AbilitySystemComponent);
	}
}