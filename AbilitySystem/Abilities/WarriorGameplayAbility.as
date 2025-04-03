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

	// UFUNCTION(BlueprintOverride)
	// void OnEndAbility(bool bWasCancelled)
	// {
	// 	if (ActivationPolicy == EWarriorAbilityActivationPolicy::OnGiven)
	// 	{
	// 		ActorInfo.AbilitySystemComponent.ClearAbility();
	// 	}
	// }

	// UFUNCTION(BlueprintOverride)
	// void OnEndAbility(FGameplayAbilitySpecHandle AH, FGameplayAbilityActorInfo AI, FGameplayAbilityActivationInfo ActivationInfo, bool bReplicateEndAbility, bool bWasCancelled)

	UFUNCTION(BlueprintPure)
	UPawnCombatComponent GetPawnCombatComponent() {
		return UPawnCombatComponent::Get(ActorInfo.AvatarActor);
	}

	UFUNCTION(BlueprintPure)
	UHeroCombatComponent GetHeroCombatComponent() {
		return UHeroCombatComponent::Get(ActorInfo.AvatarActor);
	}

	// Helpers
	UFUNCTION(BlueprintPure)
	UWarriorAbilitySystemComponent GetWarriorAbilitySystemComponentFromActorInfo() {
		return Cast<UWarriorAbilitySystemComponent>(ActorInfo.AbilitySystemComponent);
	}
}