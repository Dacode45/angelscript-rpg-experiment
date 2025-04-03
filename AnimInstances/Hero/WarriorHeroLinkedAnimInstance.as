class UWarriorHeroLinkedAnimInstance : UWarriorBaseAnimInstance
{
	UFUNCTION(BlueprintPure, Meta = (BlueprintThreadSafe))
	UWarriorHeroAnimInstance GetHeroAnimInstance() {
		return Cast<UWarriorHeroAnimInstance>(GetOwningComponent().GetAnimInstance());
	}
}